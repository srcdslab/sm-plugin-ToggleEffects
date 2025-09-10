# ToggleEffects - Copilot Coding Agent Instructions

## Repository Overview

This repository contains **ToggleEffects**, a SourcePawn plugin for SourceMod that provides a helper system for managing client preferences regarding special effects in Source engine games. The plugin allows players to toggle whether they see special effects from other plugins, with preferences stored persistently using SourceMod's ClientPrefs system.

### Key Purpose
- Provides a native function `ShowClientEffects()` for other plugins to check if a client wants to see special effects
- Manages client preferences through cookies (persistent storage)
- Offers a simple toggle interface through SourceMod's cookie menu system

## Technical Environment

### Platform & Dependencies
- **Language**: SourcePawn (.sp files)
- **Platform**: SourceMod 1.11.0-git6917 (minimum supported version)
- **Build Tool**: SourceKnight (configured via `sourceknight.yaml`)
- **Required Extensions**: ClientPrefs library
- **Target**: Source engine game servers

### Build System
The project uses **SourceKnight** as its build system:
- Configuration file: `sourceknight.yaml`
- Dependencies automatically downloaded during build
- Output: Compiled `.smx` plugin files in `/addons/sourcemod/plugins`
- Build target: `ToggleEffects`

## File Structure

```
/
├── .github/
│   ├── workflows/ci.yml          # CI/CD pipeline
│   └── dependabot.yml           # Dependency updates
├── addons/sourcemod/scripting/
│   ├── ToggleEffects.sp         # Main plugin source
│   └── include/
│       └── ToggleEffects.inc    # Native function definitions
├── sourceknight.yaml           # Build configuration
└── .gitignore                  # Git ignore rules
```

### Key Files Explained

#### `ToggleEffects.sp` - Main Plugin
- Contains the core plugin logic
- Implements client preference management
- Provides native function for other plugins
- Handles cookie menu integration

#### `ToggleEffects.inc` - Include File
- Defines native function signatures
- Provides shared plugin interface
- Handles optional plugin loading

#### `sourceknight.yaml` - Build Configuration
- Specifies SourceMod version dependency
- Defines build targets and output paths
- Configures dependency management

## Development Guidelines

### Code Standards (Repository-Specific)
- **Indentation**: Tabs (4 spaces equivalent)
- **Naming**: 
  - Functions: `PascalCase` (e.g., `OnClientCookiesCached`)
  - Variables: `camelCase` for local, `g_` prefix for global
  - Cookies: `gH_Cookie_` prefix for handles
- **Required Pragmas**: `#pragma semicolon 1` and `#pragma newdecls required`
- **Handle Management**: Use proper cleanup, check for `INVALID_HANDLE`

### Architecture Patterns
- **Event-driven**: Uses SourceMod callbacks (`OnPluginStart`, `OnClientCookiesCached`)
- **Native Interface**: Provides `ShowClientEffects()` native for other plugins
- **Cookie Integration**: Uses SourceMod's ClientPrefs for persistent storage
- **Menu Integration**: Integrates with SourceMod's cookie menu system

### Memory Management
- Always check for library existence before using features
- Use proper handle validation
- Store cookie handles in global variables for efficiency
- Clean up resources in `OnPluginEnd()` if necessary

## Build & Development Process

### Local Development
1. **Setup Environment**: Ensure SourceKnight is installed and configured
2. **Build Command**: `sourceknight build` (builds all targets)
3. **Output Location**: Built plugins appear in `/addons/sourcemod/plugins/`
4. **Testing**: Deploy to a SourceMod test server for validation

### CI/CD Pipeline
The repository uses GitHub Actions for automated building:
- **Trigger**: Push, PR, or manual dispatch
- **Build Process**: Uses `maxime1907/action-sourceknight@v1`
- **Artifacts**: Creates downloadable packages
- **Releases**: Automatic tagging and release creation
- **Versioning**: Uses 'latest' tag for main branch, semantic tags for releases

### Common Development Tasks

#### Adding New Features
1. Modify `ToggleEffects.sp` for new functionality
2. Update `ToggleEffects.inc` if adding new native functions
3. Update plugin version in `myinfo` struct
4. Test thoroughly on development server
5. Ensure backward compatibility

#### Modifying Native Interface
1. Update function signature in `ToggleEffects.inc`
2. Implement new logic in `ToggleEffects.sp`
3. Update `AskPluginLoad2()` to register new natives
4. Consider versioning implications for dependent plugins

#### Adding Configuration Options
1. Add new cookie registration in `OnPluginStart()`
2. Implement cookie handling in `OnClientCookiesCached()`
3. Add menu options in `CookieMenu_GlobalEffects()`
4. Update validation and default value logic

### Testing Strategy

#### Manual Testing
1. **Server Deployment**: Copy `.smx` files to test server
2. **Functionality Testing**: 
   - Verify cookie menu integration works
   - Test preference persistence across reconnections
   - Validate native function returns correct values
3. **Integration Testing**: Test with plugins that use `ShowClientEffects()`

#### Automated Testing
- CI builds validate compilation
- Consider adding basic syntax/style checks
- Integration tests should be done with dependent plugins

## Troubleshooting

### Common Issues

#### Build Failures
- **Missing Dependencies**: Check `sourceknight.yaml` for correct SourceMod version
- **Syntax Errors**: Use SourceMod compiler error messages for debugging
- **Include Issues**: Ensure include paths are correct in `#include` statements

#### Runtime Issues
- **Library Not Found**: Check if ClientPrefs extension is loaded on server
- **Cookie Issues**: Verify cookie registration and client caching
- **Native Errors**: Ensure proper parameter validation in native functions

#### CI/CD Issues
- **Action Failures**: Check SourceKnight action version compatibility
- **Release Problems**: Verify GitHub token permissions for releases
- **Artifact Issues**: Ensure proper file paths in CI configuration

### Debugging Tips
1. Use `LogMessage()` for debugging instead of `PrintToServer()`
2. Check SourceMod error logs for runtime issues
3. Use `sm plugins list` to verify plugin loading
4. Test cookie functionality with `sm_cookie` commands

## Plugin Integration

### For Other Plugin Developers
To use ToggleEffects in your plugin:

1. **Include the header**:
   ```sourcepawn
   #include <ToggleEffects>
   ```

2. **Check client preferences**:
   ```sourcepawn
   if (ShowClientEffects(client))
   {
       // Show special effects to this client
   }
   ```

3. **Handle optional loading**:
   - The include file handles optional plugin loading
   - Plugin will work even if ToggleEffects is not installed

### Dependencies
- **Required**: SourceMod 1.11.0+ with ClientPrefs extension
- **Optional**: No optional dependencies
- **Conflicts**: None known

## Maintenance Notes

### Version Management
- Update version string in `myinfo` struct for releases
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Tag releases in Git for proper CI/CD handling

### Security Considerations
- Cookie data is properly escaped and validated
- No SQL injection risks (uses built-in cookie system)
- No file system access or external network calls

### Performance Considerations
- Minimal overhead (only stores boolean preference per client)
- Cookie caching reduces database queries
- Native function is O(1) lookup

### Future Enhancements
- Consider adding translation file support for messages
- Potential for more granular effect categories
- Integration with admin menu systems
- Configuration file for default preferences

## Quick Reference Commands

```bash
# Build plugin
sourceknight build

# Check CI status
git push origin main  # Triggers CI build

# Test locally (after building)
cp .sourceknight/package/addons/sourcemod/plugins/ToggleEffects.smx /path/to/server/addons/sourcemod/plugins/

# Check plugin status on server
sm plugins list | grep ToggleEffects
```

This plugin serves as a foundation for special effects management in SourceMod servers and should be treated as a stable library component that other plugins depend on.