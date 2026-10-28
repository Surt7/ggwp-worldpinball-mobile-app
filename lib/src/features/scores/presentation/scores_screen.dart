import 'package:flutter/material.dart';
import '../../../shared/widgets/game_mode_filter_bar.dart';
import '../data/scores_repository.dart';
import '../../games/data/game_session_repository.dart';
import '../../games/data/lobby_hub_service.dart';
import 'widgets/active_session_card.dart';

/// Screen displaying personal scores with real aggregate stats and lazy-loaded paginated list.
class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with WidgetsBindingObserver {
  final _repository = ScoresRepository();
  final _scrollController = ScrollController();

  String _selectedModeId = 'all';
  String _selectedLicense = 'Resident Evil: Death Island';

  // Active game session and SignalR live connection
  final _sessionRepository = GameSessionRepository();
  final _hubService = LobbyHubService();
  Map<String, dynamic>? _activeSession;
  bool _isLiveConnected = false;

  // Stats
  Map<String, dynamic>? _stats;
  bool _isLoadingStats = true;

  // Games pagination
  final List<Map<String, dynamic>> _games = [];
  bool _isLoadingGames = false;
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAll();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hubService.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Disconnect immediately when app leaves screen to preserve mobile battery
      _hubService.disconnect();
      if (mounted) setState(() => _isLiveConnected = false);
    } else if (state == AppLifecycleState.resumed) {
      // Re-establish real-time connection if a game session is currently active
      _connectLiveHubIfNeeded();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingGames && _hasMore) {
        _loadMoreGames();
      }
    }
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoadingStats = true;
      _isLoadingGames = true;
      _games.clear();
      _currentSkip = 0;
      _hasMore = true;
    });

    try {
      final statsFuture = _repository.getMyScoreStats(
        modeCode: _selectedModeId,
      );
      final gamesFuture = _repository.getMyScores(
        skip: 0,
        take: _pageSize,
        modeCode: _selectedModeId,
      );

      final sessionFuture = _sessionRepository.getMyActiveSession();

      final stats = await statsFuture;
      final games = await gamesFuture;

      final session = await sessionFuture;

      if (!mounted) return;
      setState(() {
        _stats = stats;
        _isLoadingStats = false;
        _games.addAll(games);
        _activeSession = session;
        _isLoadingGames = false;
        _currentSkip = games.length;
        _hasMore = games.length >= _pageSize;
      });
      _connectLiveHubIfNeeded();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingStats = false;
        _isLoadingGames = false;
      });
    }
  }

  void _connectLiveHubIfNeeded() {
    final sessionId = _activeSession?['sessionId']?.toString();
    if (sessionId != null && sessionId.isNotEmpty) {
      _hubService
          .connect(
            sessionId: sessionId,
            onLobbyUpdated: (update) {
              if (!mounted) return;
              final newState = update['sessionState'] ?? update['SessionState'];
              if (newState != null) {
                final stateStr = newState.toString();
                if (stateStr.toLowerCase() == 'finished' ||
                    stateStr.toLowerCase() == 'cancelled') {
                  // Session closed -> refresh all stats and scores
                  _loadAll();
                } else {
                  setState(() {
                    if (_activeSession != null) {
                      final slots = update['slots'] ?? update['Slots'];
                      _activeSession =
                          Map<String, dynamic>.from(_activeSession!)
                            ..['state'] = stateStr
                            ..['slots'] = slots;
                    }
                  });
                }
              }
            },
            onConnectionClosed: () {
              if (mounted) {
                setState(() => _isLiveConnected = false);
              }
            },
          )
          .then((_) {
            if (mounted) {
              setState(() => _isLiveConnected = _hubService.isConnected);
            }
          });
    } else {
      _hubService.disconnect();
      if (mounted && _isLiveConnected) {
        setState(() => _isLiveConnected = false);
      }
    }
  }

  Future<void> _loadMoreGames() async {
    if (_isLoadingGames || !_hasMore) return;
    setState(() => _isLoadingGames = true);

    try {
      final moreGames = await _repository.getMyScores(
        skip: _currentSkip,
        take: _pageSize,
        modeCode: _selectedModeId,
      );

      if (!mounted) return;
      setState(() {
        _games.addAll(moreGames);
        _currentSkip += moreGames.length;
        _isLoadingGames = false;
        _hasMore = moreGames.length >= _pageSize;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingGames = false);
    }
  }

  static Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount =
        _stats?['totalGames']?.toString() ?? (_isLoadingStats ? '...' : '0');
    final bestScore =
        _stats?['bestScore']?.toString() ?? (_isLoadingStats ? '...' : '-');

    return RefreshIndicator(
      color: const Color(0xFFE53935),
      backgroundColor: const Color(0xFF1E1E1E),
      onRefresh: _loadAll,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _games.length + 4,
        // Header, Stats, Section Title, [Games...], Loading/End
        itemBuilder: (context, index) {
          // 0. Filter Bar
          if (index == 0) {
            return Column(
              children: [
                GameModeFilterBar(
                  selectedModeId: _selectedModeId,
                  onModeSelected: (modeId) {
                    if (_selectedModeId == modeId) return;
                    setState(() => _selectedModeId = modeId);
                    _loadAll();
                  },
                  selectedLicense: _selectedLicense,
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          // 1. Live Active Session Banner (if any) + Stats Summary Banner
          if (index == 1) {
            return Column(
              children: [
                if (_activeSession != null) ...[
                  ActiveSessionCard(
                    session: _activeSession!,
                    isLiveConnected: _isLiveConnected,
                  ),
                  const SizedBox(height: 14),
                ],
                Card(
                  color: const Color(0xFF1E1E1E),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'TOTAL PARTIES',
                          totalCount,
                          Colors.white,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade800,
                        ),
                        _buildStatItem(
                          'MEILLEUR SCORE',
                          bestScore,
                          const Color(0xFFE53935),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }

          // 2. Section Title
          if (index == 2) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HISTORIQUE RÉCENT',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.1,
                    ),
                  ),
                  if (_selectedModeId != 'all')
                    Text(
                      'Mode : ${_selectedModeName()}',
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            );
          }

          // Last item: Loading indicator or empty state
          if (index == _games.length + 3) {
            if (_isLoadingGames) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE53935),
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            if (_games.isEmpty && !_isLoadingStats) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sports_esports_outlined,
                        size: 48,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aucune partie enregistrée en mode ${_selectedModeName()}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox(height: 24);
          }

          // Games items
          final game = _games[index - 3];
          final modeName = game['modeName']?.toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade900),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              title: Text(
                game['machine'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    game['date'].toString(),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  if (modeName != null && modeName.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        modeName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: Text(
                game['score'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFFE53935),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _selectedModeName() {
    final mode = kGameModes.firstWhere(
      (m) => m.id == _selectedModeId,
      orElse: () => const GameModeItem(
        id: 'all',
        label: 'Tous',
        icon: Icons.sports_esports,
      ),
    );
    return mode.label;
  }
}
