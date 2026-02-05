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
    # Only show banner in interactive shells
    if [[ $- == *i* ]]; then
      echo "LaTeX environment for CV loaded"
      echo "Commands: build, build-no-contact, build-all, clean"
    fi

    _find_tex() {
      local texfile=$(find . -maxdepth 1 -name '*.tex' -type f | head -1)
      if [ -z "$texfile" ]; then
        echo "No .tex file found" >&2
        return 1
      fi
      echo "$texfile"
    }

    build() {
      local texfile=$(_find_tex) || return 1
      local base="''${texfile%.tex}"
      latexmk -pdf "$texfile"
      cp "$base.pdf" cv.pdf
      latexmk -c "$texfile"
    }

    build-no-contact() {
      local texfile=$(_find_tex) || return 1
      sed -i 's/\\hidecontactfalse/\\hidecontacttrue/' "$texfile"
      latexmk -pdf "$texfile"
      sed -i 's/\\hidecontacttrue/\\hidecontactfalse/' "$texfile"
      latexmk -c "$texfile"
    }

    build-all() {
      local texfile=$(_find_tex) || return 1
      local base="''${texfile%.tex}"
      latexmk -pdf "$texfile"
      cp "$base.pdf" cv.pdf
      cp "$base.pdf" "$base (with contact).pdf"
      sed -i 's/\\hidecontactfalse/\\hidecontacttrue/' "$texfile"
      latexmk -pdf "$texfile"
      sed -i 's/\\hidecontacttrue/\\hidecontactfalse/' "$texfile"
      cp "$base.pdf" "$base (no contact).pdf"
      latexmk -pdf "$texfile"
      latexmk -c "$texfile"
    }

    clean() {
      local texfile=$(_find_tex) || return 1
      latexmk -C "$texfile"
    }
  '';
}
