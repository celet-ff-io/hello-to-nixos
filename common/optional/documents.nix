# Documents
{pkgs, ...}: {
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    chafa
    imagemagick

    ghostscript
    mermaid-cli
    (texlive.combine {
      inherit
        (texlive)
        scheme-medium
        latexmk
        collection-langchinese
        ;
    })
  ];
}
