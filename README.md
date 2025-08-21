# BrightPal Updates Repository

This repository hosts the auto-update files for the BrightPal desktop application.

## Structure

```
updates/
├── latest.json          # Main update metadata
├── release-notes.json   # Version changelog
└── [update files]       # DMG, EXE, DEB files
```

## How it works

1. **latest.json**: Contains information about the latest available version
2. **release-notes.json**: Contains detailed changelog for each version
3. **Update files**: The actual installer files for each platform

## Platforms Supported

- **macOS**: Universal (x86_64 + ARM64) DMG files
- **Windows**: x64 NSIS installer
- **Linux**: DEB packages (future)

## GitHub Pages

This repository uses GitHub Pages to host the update files at:
`https://nishanbaral.github.io/brightpal-updates/updates/`

## Adding New Updates

1. Add new update files to the `updates/` directory
2. Update `latest.json` with new version information
3. Update `release-notes.json` with changelog
4. Commit and push to trigger automatic deployment

## Security

All update files are signed with the BrightPal code signing certificate to ensure authenticity.
