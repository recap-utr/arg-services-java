const config = {
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "conventionalcommits",
      },
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        preset: "conventionalcommits",
      },
    ],
    [
      "@semantic-release/changelog",
      {
        changelogTitle: "# Changelog",
      },
    ],
    [
      // Buf
      "@semantic-release/exec",
      {
        prepareCmd:
          "buf generate --include-imports buf.build/recap/arg-services",
      },
    ],
    [
      "@semantic-release/github",
      {
        // assets: "dist/*.tgz",
        failComment: false,
        addReleases: "bottom",
      },
    ],
    [
      "@semantic-release/git",
      {
        message: "chore(release): ${nextRelease.version}",
      },
    ],
  ],
};

module.exports = config;
