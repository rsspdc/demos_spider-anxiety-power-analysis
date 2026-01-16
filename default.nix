let
 # pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2025-06-13.tar.gz") {};
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2025-09-01.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      datasauRus
      devtools
      dplyr
      ggplot2
      gt
      magrittr
      markdown
      purrr
      qrcode
      readr
      renv
      rix
      rmarkdown
      rstudioapi
      tidymodels
      ;
  };
 
  git_archive_pkgs = [
    (pkgs.rPackages.buildRPackage {
      name = "colorblindr";
      src = pkgs.fetchgit {
        url = "https://github.com/clauswilke/colorblindr";
        rev = "90d64f8fc50bee7060be577f180ae019a9bbbb84";
        sha256 = "sha256-VKVFBKJGWJfJRj/lqCbawiaNAWkztKa1kyIdNluW2E0=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          colorspace
          ggplot2
          cowplot
          shiny
          scales;
      };
    })
  ];

  system_packages = builtins.attrValues {
    inherit (pkgs) 
      git
      git-lfs
      glibcLocales
      nix
      quarto
      R;
  };
 
  wrapped_pkgs = pkgs.rstudioWrapper.override {
    packages = [ git_archive_pkgs rpkgs  ];
  };
 
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
  LC_ALL = "en_US.UTF-8";
  LC_TIME = "en_US.UTF-8";
  LC_MONETARY = "en_US.UTF-8";
  LC_PAPER = "en_US.UTF-8";
  LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [ git_archive_pkgs rpkgs system_packages wrapped_pkgs ];
  
}
