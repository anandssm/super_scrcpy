import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import '../core/app_colors.dart';
import '../models/scrcpy_config.dart';

class ConfigProfile {
  String name;
  ScrcpyConfig config;
  DateTime createdAt;
  DateTime updatedAt;

  ConfigProfile({
    required this.name,
    required this.config,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'config': config.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ConfigProfile.fromJson(Map<String, dynamic> json) {
    return ConfigProfile(
      name: json['name'] as String? ?? 'Unnamed',
      config: ScrcpyConfig.fromJson(
        (json['config'] as Map<String, dynamic>?) ?? {},
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ReleaseInfo {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;
  final DateTime publishedAt;
  final bool isPrerelease;

  const ReleaseInfo({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
    required this.publishedAt,
    this.isPrerelease = false,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) {
    return ReleaseInfo(
      tagName: json['tag_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      body: json['body'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      publishedAt:
          DateTime.tryParse(json['published_at'] as String? ?? '') ??
          DateTime.now(),
      isPrerelease: json['prerelease'] as bool? ?? false,
    );
  }
}

class SettingsProvider extends ChangeNotifier {
  static const String _profilesKey = 'config_profiles';
  static const String _activeProfileKey = 'active_profile_name';
  static const String _accentColorKey = 'accent_color';
  static const String _useDynamicColorKey = 'use_dynamic_color';
  static const String _repoOwner = 'anandssm';
  static const String _repoName = 'super_scrcpy';
  static const String _releaseManifestUrl =
      'https://raw.githubusercontent.com/anandssm/super_scrcpy/main/docs/release.json';
  static const String _releasesPageUrl =
      'https://github.com/$_repoOwner/$_repoName/releases';

  List<ConfigProfile> _profiles = [];
  String _activeProfileName = 'Default';
  String _currentVersion = '0.0.0';
  Future<void>? _appVersionLoad;

  Color _accentColor = AppColors.defaultAccent;
  bool _useDynamicColor = true;

  bool _isCheckingUpdate = false;
  ReleaseInfo? _latestRelease;
  String? _updateError;
  bool _updateAvailable = false;

  bool _isFetchingChangelog = false;
  List<ReleaseInfo> _releases = [];
  String? _changelogError;
  DateTime? _lastChangelogFetch;

  List<ConfigProfile> get profiles => _profiles;
  String get activeProfileName => _activeProfileName;
  String get currentVersion => _currentVersion;

  Color get accentColor => _accentColor;
  bool get useDynamicColor => _useDynamicColor;

  bool get isCheckingUpdate => _isCheckingUpdate;
  ReleaseInfo? get latestRelease => _latestRelease;
  String? get updateError => _updateError;
  bool get updateAvailable => _updateAvailable;

  bool get isFetchingChangelog => _isFetchingChangelog;
  List<ReleaseInfo> get releases => _releases;
  String? get changelogError => _changelogError;

  ConfigProfile get activeProfile {
    final match = _profiles.where((p) => p.name == _activeProfileName);
    if (match.isNotEmpty) return match.first;
    if (_profiles.isNotEmpty) return _profiles.first;
    final fallback = ConfigProfile(name: 'Default', config: ScrcpyConfig());
    _profiles.add(fallback);
    return fallback;
  }

  SettingsProvider() {
    _appVersionLoad = _loadAppVersion();
    _loadProfiles();
    _loadAccentColor();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version.trim().isNotEmpty) {
        _currentVersion = packageInfo.version.trim();
        notifyListeners();
      }
    } catch (_) {
      // Keep fallback value when platform package info is unavailable.
    }
  }

  Future<void> _loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profilesKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _profiles = list
            .map((e) => ConfigProfile.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _profiles = [ConfigProfile(name: 'Default', config: ScrcpyConfig())];
      }
    } else {
      _profiles = [ConfigProfile(name: 'Default', config: ScrcpyConfig())];
    }
    _activeProfileName =
        prefs.getString(_activeProfileKey) ?? _profiles.first.name;
    notifyListeners();
  }

  Future<void> _saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_profilesKey, json);
    await prefs.setString(_activeProfileKey, _activeProfileName);
  }

  void setActiveProfile(String name) {
    _activeProfileName = name;
    notifyListeners();
    _saveProfiles();
  }

  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_accentColorKey);
    if (colorValue != null) {
      _accentColor = Color(colorValue);
    }
    _useDynamicColor = prefs.getBool(_useDynamicColorKey) ?? true;
    notifyListeners();
  }

  Future<void> _saveAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, _accentColor.toARGB32());
    await prefs.setBool(_useDynamicColorKey, _useDynamicColor);
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    _useDynamicColor = false;
    notifyListeners();
    _saveAccentColor();
  }

  void setUseDynamicColor(bool value) {
    _useDynamicColor = value;
    notifyListeners();
    _saveAccentColor();
  }

  ScrcpyConfig getActiveConfig() => activeProfile.config;

  void saveActiveConfig(ScrcpyConfig config) {
    activeProfile.config = config;
    activeProfile.updatedAt = DateTime.now();
    _saveProfiles();
    notifyListeners();
  }

  void addProfile(String name) {
    if (_profiles.any((p) => p.name == name)) return;
    _profiles.add(ConfigProfile(name: name, config: ScrcpyConfig()));
    _saveProfiles();
    notifyListeners();
  }

  void duplicateProfile(String sourceName, String newName) {
    final source = _profiles.where((p) => p.name == sourceName);
    if (source.isEmpty || _profiles.any((p) => p.name == newName)) return;
    final json = source.first.config.toJson();
    _profiles.add(
      ConfigProfile(name: newName, config: ScrcpyConfig.fromJson(json)),
    );
    _saveProfiles();
    notifyListeners();
  }

  void renameProfile(String oldName, String newName) {
    if (_profiles.any((p) => p.name == newName)) return;
    final profile = _profiles.where((p) => p.name == oldName);
    if (profile.isEmpty) return;
    profile.first.name = newName;
    if (_activeProfileName == oldName) {
      _activeProfileName = newName;
    }
    _saveProfiles();
    notifyListeners();
  }

  void deleteProfile(String name) {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.name == name);
    if (_activeProfileName == name) {
      _activeProfileName = _profiles.first.name;
    }
    _saveProfiles();
    notifyListeners();
  }

  Future<String?> exportProfiles() async {
    try {
      final savePath = await FilePicker.saveFile(
        dialogTitle: 'Export Configurations',
        fileName: 'super_scrcpy_configs.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (savePath == null) return null;

      final exportData = {
        'app': 'Super Scrcpy',
        'version': _currentVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'profiles': _profiles.map((p) => p.toJson()).toList(),
      };

      final file = File(savePath);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(exportData),
      );
      return savePath;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> importProfiles() async {
    try {
      final result = await FilePicker.pickFiles(
        dialogTitle: 'Import Configurations',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) return 0;

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      final importedProfiles = <ConfigProfile>[];
      final profilesList = data['profiles'] as List<dynamic>?;
      if (profilesList == null) return 0;

      for (final item in profilesList) {
        final profile = ConfigProfile.fromJson(item as Map<String, dynamic>);

        var name = profile.name;
        int suffix = 1;
        while (_profiles.any((p) => p.name == name)) {
          name = '${profile.name} ($suffix)';
          suffix++;
        }
        profile.name = name;
        importedProfiles.add(profile);
      }

      _profiles.addAll(importedProfiles);
      _saveProfiles();
      notifyListeners();
      return importedProfiles.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> checkForUpdate() async {
    if (_appVersionLoad != null) {
      await _appVersionLoad;
    }

    _isCheckingUpdate = true;
    _updateError = null;
    _updateAvailable = false;
    notifyListeners();

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(Uri.parse(_releaseManifestUrl));
      request.headers.set('Accept', 'application/json');
      request.headers.set('User-Agent', 'SuperScrcpy/$_currentVersion');

      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        final latestVersion = (json['version'] as String? ?? '').trim();
        if (latestVersion.isEmpty) {
          _updateError = 'Invalid release manifest: missing version';
        } else {
          final htmlUrl = (json['html_url'] as String? ?? '').trim();
          _latestRelease = ReleaseInfo.fromJson({
            'tag_name': latestVersion,
            'name': json['name'] as String? ?? 'Release $latestVersion',
            'body': json['notes'] as String? ?? '',
            'html_url': htmlUrl.isNotEmpty ? htmlUrl : _releasesPageUrl,
            'published_at': json['published_at'] as String?,
            'prerelease': json['prerelease'] as bool? ?? false,
          });
          _updateAvailable = _isNewerVersion(latestVersion);
        }
      } else if (response.statusCode == 404) {
        _updateError = 'Release manifest not found';
      } else {
        _updateError = 'Release check error (${response.statusCode})';
      }
    } catch (e) {
      _updateError = 'Network error: ${e.toString().split('\n').first}';
    } finally {
      client.close(force: true);
    }

    _isCheckingUpdate = false;
    notifyListeners();
  }

  bool _isNewerVersion(String tagName) {
    final remoteParts = _extractSemverParts(tagName);
    final currentParts = _extractSemverParts(_currentVersion);

    for (int i = 0; i < 3; i++) {
      final r = remoteParts[i];
      final c = currentParts[i];
      if (r > c) return true;
      if (r < c) return false;
    }
    return false;
  }

  List<int> _extractSemverParts(String input) {
    final cleaned = input.trim().replaceFirst(RegExp(r'^[vV]'), '');
    final matches = RegExp(r'\d+').allMatches(cleaned);
    final values = matches
        .take(3)
        .map((m) => int.tryParse(m.group(0) ?? '0') ?? 0)
        .toList();
    while (values.length < 3) {
      values.add(0);
    }
    return values;
  }

  Future<void> fetchChangelog() async {
    if (_releases.isNotEmpty && _lastChangelogFetch != null) {
      if (DateTime.now().difference(_lastChangelogFetch!).inHours < 1) {
        return;
      }
    }

    _isFetchingChangelog = true;
    _changelogError = null;
    notifyListeners();

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(
        Uri.parse(
          'https://api.github.com/repos/$_repoOwner/$_repoName/releases?per_page=20',
        ),
      );
      request.headers.set('Accept', 'application/vnd.github.v3+json');
      request.headers.set('User-Agent', 'SuperScrcpy/$_currentVersion');

      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final decoded = jsonDecode(body);
        if (decoded is List<dynamic> && decoded.isNotEmpty) {
          _releases = decoded
              .whereType<Map<String, dynamic>>()
              .map(ReleaseInfo.fromJson)
              .toList();
          _lastChangelogFetch = DateTime.now();
        } else {
          _releases = await _fetchChangelogFromManifest();
          if (_releases.isEmpty) {
            _changelogError = 'No releases found';
          } else {
            _lastChangelogFetch = DateTime.now();
          }
        }
      } else {
        _releases = await _fetchChangelogFromManifest();
        if (_releases.isEmpty) {
          _changelogError = 'GitHub API error (${response.statusCode})';
        } else {
          _lastChangelogFetch = DateTime.now();
        }
      }
    } catch (e) {
      _releases = await _fetchChangelogFromManifest();
      if (_releases.isEmpty) {
        _changelogError = 'Network error: ${e.toString().split('\n').first}';
      } else {
        _lastChangelogFetch = DateTime.now();
      }
    } finally {
      client.close(force: true);
    }

    _isFetchingChangelog = false;
    notifyListeners();
  }

  void clearChangelogCache() {
    _releases = [];
    _changelogError = null;
    _lastChangelogFetch = null;
  }

  Future<List<ReleaseInfo>> _fetchChangelogFromManifest() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    try {
      final manifestRequest = await client.getUrl(
        Uri.parse(_releaseManifestUrl),
      );
      manifestRequest.headers.set('Accept', 'application/json');
      manifestRequest.headers.set('User-Agent', 'SuperScrcpy/$_currentVersion');
      final manifestResponse = await manifestRequest.close();

      if (manifestResponse.statusCode != 200) {
        return const [];
      }

      final manifestBody = await manifestResponse
          .transform(utf8.decoder)
          .join();
      final manifest = jsonDecode(manifestBody) as Map<String, dynamic>;

      final version = (manifest['version'] as String? ?? '').trim();
      final name = (manifest['name'] as String? ?? '').trim();
      final notes = (manifest['notes'] as String? ?? '').trim();
      final changelogUrl = (manifest['changelog_url'] as String? ?? '').trim();
      final publishedAt =
          DateTime.tryParse(manifest['published_at'] as String? ?? '') ??
          DateTime.now();
      final prerelease = manifest['prerelease'] as bool? ?? false;

      if (changelogUrl.isNotEmpty) {
        final changelogRequest = await client.getUrl(Uri.parse(changelogUrl));
        changelogRequest.headers.set('Accept', 'text/plain');
        changelogRequest.headers.set(
          'User-Agent',
          'SuperScrcpy/$_currentVersion',
        );
        final changelogResponse = await changelogRequest.close();

        if (changelogResponse.statusCode == 200) {
          final markdown = await changelogResponse
              .transform(utf8.decoder)
              .join();
          final parsed = _parseMarkdownChangelog(markdown);
          if (parsed.isNotEmpty) {
            return parsed;
          }
        }
      }

      if (version.isEmpty) {
        return const [];
      }

      return [
        ReleaseInfo(
          tagName: version,
          name: name.isNotEmpty ? name : 'Release $version',
          body: notes,
          htmlUrl: _releasesPageUrl,
          publishedAt: publishedAt,
          isPrerelease: prerelease,
        ),
      ];
    } catch (_) {
      return const [];
    } finally {
      client.close(force: true);
    }
  }

  List<ReleaseInfo> _parseMarkdownChangelog(String markdown) {
    final headerPattern = RegExp(
      r'^##\s+\[?([^\]\n]+)\]?\s*-\s*(\d{4}-\d{2}-\d{2})\s*$',
      multiLine: true,
    );
    final matches = headerPattern.allMatches(markdown).toList();
    if (matches.isEmpty) {
      return const [];
    }

    final releases = <ReleaseInfo>[];
    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final nextStart = i + 1 < matches.length
          ? matches[i + 1].start
          : markdown.length;
      final version = (match.group(1) ?? '').trim();
      final dateText = (match.group(2) ?? '').trim();
      final body = markdown.substring(match.end, nextStart).trim();
      if (version.isEmpty) {
        continue;
      }

      releases.add(
        ReleaseInfo(
          tagName: version,
          name: 'v$version',
          body: body,
          htmlUrl: _releasesPageUrl,
          publishedAt: DateTime.tryParse(dateText) ?? DateTime.now(),
        ),
      );
    }

    return releases;
  }
}
