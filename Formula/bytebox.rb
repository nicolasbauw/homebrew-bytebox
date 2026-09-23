class Bytebox < Formula
  desc "Amstrad CPC 6128 emulator"
  # amstrad_cpc (github.com/nicolasbauw/amstrad_cpc) est un dépôt privé
  # depuis 2026-09 : un lien vers lui ne mènerait nulle part pour qui
  # installe via ce tap. La page officielle, pas encore publiée à ce jour.
  homepage "https://theorangenerd.ovh/#bb"
  # Binaire déjà compilé par la GitHub Action d'amstrad_cpc (job "macos"),
  # hébergé sur le site de l'auteur — pas construit ici. Ce n'est pas non
  # plus construit "from source" en CI depuis ce tarball : plus personne
  # d'autre que l'auteur ne peut télécharger le tarball source d'un dépôt
  # privé (voir la conversation qui a introduit ce commentaire, dans le
  # dépôt amstrad_cpc).
  url "https://theorangenerd.ovh/cpc/bytebox-2.1.0-macos-arm64.tar.gz"
  version "2.1.0"
  sha256 "921d08f6c4b2c63574aaf30061fc3243ed1f28d4bb6119e016368812ab9f1bd6"
  license "MIT"

  depends_on "sdl2"

  def install
    bin.install "bytebox"
    prefix.install "ByteBox.app" if OS.mac?
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      ByteBox also installs as a macOS bundle (#{prefix}/ByteBox.app), for
      normal launching/pinning from the Dock or Launchpad — instead of the
      bare binary in #{bin}. To add it to Applications:

        ln -s "#{prefix}/ByteBox.app" /Applications/ByteBox.app

      This binary is downloaded pre-built (from theorangenerd.ovh) rather
      than compiled here, and is unsigned. `brew` fetches it with curl, not
      Safari, so it is normally never quarantined — but if macOS still
      refuses to launch it ("cannot be opened because the developer cannot
      be verified", or on newer macOS "is damaged and can't be opened" for
      the very same reason), clear the flag by hand:

        xattr -d com.apple.quarantine "#{prefix}/ByteBox.app"
    EOS
  end

  test do
    # Pas de sous-commande "--version" ni "--help" côté ByteBox (voir
    # bytebox/src/main.rs) : lancer le binaire sans argument ouvrirait une
    # vraie fenêtre SDL2/GPU, ce qu'un `brew test` headless en CI ne peut
    # pas faire. Seule vérification possible ici : le binaire a bien été
    # installé et est exécutable.
    assert_predicate bin/"bytebox", :exist?
    assert_predicate bin/"bytebox", :executable?
  end
end
