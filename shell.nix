{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        scheme-basic
        latexmk

        # Document class
        moderncv

        # Required packages from tools bundle
        tools  # contains tabularx

        # Other required packages
        psnfss  # contains pifont
        hyphenat
        geometry
        hyperref
        anyfontsize
        eso-pic

        # moderncv dependencies
        etoolbox
        xcolor
        fancyhdr
        ifmtarg
        microtype
        fontawesome5
        academicons
        pgf  # provides tikz

        # Font packages
        cm-super
        lm

        # Additional required
        graphics
        oberdiek
        url
        colortbl
        multirow
        arydshln
        ;
    })
  ];

  shellHook = ''
    echo "LaTeX environment for CV loaded"
    echo "Commands: build, build-no-contact, build-all, clean"

    build() {
      latexmk -pdf -cd curriculum-vitae/'Adam James - CV.tex'
      cp curriculum-vitae/'Adam James - CV.pdf' curriculum-vitae/cv.pdf
      latexmk -c -cd curriculum-vitae/'Adam James - CV.tex'
    }

    build-no-contact() {
      sed -i 's/\\hidecontactfalse/\\hidecontacttrue/' curriculum-vitae/'Adam James - CV.tex'
      latexmk -pdf -cd curriculum-vitae/'Adam James - CV.tex'
      sed -i 's/\\hidecontacttrue/\\hidecontactfalse/' curriculum-vitae/'Adam James - CV.tex'
      latexmk -c -cd curriculum-vitae/'Adam James - CV.tex'
    }

    build-all() {
      latexmk -pdf -cd curriculum-vitae/'Adam James - CV.tex'
      cp curriculum-vitae/'Adam James - CV.pdf' curriculum-vitae/cv.pdf
      cp curriculum-vitae/'Adam James - CV.pdf' curriculum-vitae/'Adam James - CV (with contact).pdf'
      sed -i 's/\\hidecontactfalse/\\hidecontacttrue/' curriculum-vitae/'Adam James - CV.tex'
      latexmk -pdf -cd curriculum-vitae/'Adam James - CV.tex'
      sed -i 's/\\hidecontacttrue/\\hidecontactfalse/' curriculum-vitae/'Adam James - CV.tex'
      cp curriculum-vitae/'Adam James - CV.pdf' curriculum-vitae/'Adam James - CV (no contact).pdf'
      latexmk -pdf -cd curriculum-vitae/'Adam James - CV.tex'
      latexmk -c -cd curriculum-vitae/'Adam James - CV.tex'
    }

    clean() {
      latexmk -C -cd curriculum-vitae/'Adam James - CV.tex'
    }
  '';
}
