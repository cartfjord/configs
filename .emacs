(global-linum-mode t)
(load-theme 'tango-dark)
(cua-mode t)
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")
(setq compilation-scroll-output t)
(setq inhibit-startup-screen t)



(with-eval-after-load 'verilog-mode
  (defvar modi/verilog-eda-vendor "cadence" ; "xyz"
    "EDA vendor tools to use for verilog/SV compilation, simulation, etc.")

  (defvar modi/verilog-cadence-linter '("irun" "-hal")
    "Verilog/SV linting command using Cadence.")
  (defvar modi/verilog-cadence-compiler '("irun" "-compile")
    "Verilog/SV compilation command using Cadence.")
  (defvar modi/verilog-cadence-simulator '("irun" "-access" "rwc")
    "Verilog/SV simulation command using Cadence.")

  (defvar modi/verilog-xyz-linter '("these" "need" "to" "be" "defined")
    "Verilog/SV linting command using Xyz.")
  (defvar modi/verilog-xyz-compiler '("these" "need" "to" "be" "defined")
    "Verilog/SV compilation command using Xyz.")
  (defvar modi/verilog-xyz-simulator '("these" "need" "to" "be" "defined")
    "Verilog/SV simulation command using Xyz.")

  ;; (setq verilog-tool 'verilog-linter)
  (setq verilog-tool 'verilog-compiler)
  ;; (setq verilog-tool 'verilog-simulator)

  (defun modi/verilog-tool-setup ()
    "Set up for running verilog/SV compilation, simulation, etc.
This function needs to be run in `verilog-mode-hook'."
    (let* ((vendor-linter (symbol-value (intern (concat "modi/verilog-"
                                                        modi/verilog-eda-vendor
                                                        "-linter"))))
           (cmd-linter (mapconcat 'identity vendor-linter " "))
           (vendor-compiler (symbol-value (intern (concat "modi/verilog-"
                                                          modi/verilog-eda-vendor
                                                          "-compiler"))))
           (cmd-compiler (mapconcat 'identity vendor-compiler " "))
           (vendor-simulator (symbol-value (intern (concat "modi/verilog-"
                                                           modi/verilog-eda-vendor
                                                           "-simulator"))))
           (cmd-simulator (mapconcat 'identity vendor-simulator " ")))
      (when (executable-find (car vendor-linter))
        (setq verilog-linter cmd-linter))
      (when (executable-find (car vendor-compiler))
        (setq verilog-compiler cmd-compiler))
      (when (executable-find (car vendor-simulator))
        (setq verilog-simulator cmd-simulator)))
    (verilog-set-compile-command))
  (add-hook 'verilog-mode-hook #'modi/verilog-tool-setup))




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(vhdl-clock-edge-condition (quote function))
 '(vhdl-compiler "ModelSim")
 '(vhdl-compiler-alist
   (quote
    (("ADVance MS" "vacom" "-work \\1" "make" "-f \\1" nil "valib \\1; vamap \\2 \\1" "./" "work/" "Makefile" "adms"
      ("^\\s-+\\([0-9]+\\):\\s-+" nil 1 nil)
      ("Compiling file \\(.+\\)" 1)
      ("ENTI/\\1.vif" "ARCH/\\1-\\2.vif" "CONF/\\1.vif" "PACK/\\1.vif" "BODY/\\1.vif" upcase))
     ("Aldec" "vcom" "-work \\1" "make" "-f \\1" nil "vlib \\1; vmap \\2 \\1" "./" "work/" "Makefile" "aldec"
      (".* ERROR [^:]+: \".*\" \"\\([^ \\t\\n]+\\)\" \\([0-9]+\\) \\([0-9]+\\)" 1 2 3)
      ("" 0)
      nil)
     ("Cadence Leapfrog" "cv" "-work \\1 -file" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "leapfrog"
      ("duluth: \\*E,[0-9]+ (\\([^ \\t\\n]+\\),\\([0-9]+\\)):" 1 2 nil)
      ("" 0)
      ("\\1/entity" "\\2/\\1" "\\1/configuration" "\\1/package" "\\1/body" downcase))
     ("Cadence NC" "ncvhdl" "-work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "ncvhdl"
      ("ncvhdl_p: \\*E,\\w+ (\\([^ \\t\\n]+\\),\\([0-9]+\\)|\\([0-9]+\\)):" 1 2 3)
      ("" 0)
      ("\\1/entity/pc.db" "\\2/\\1/pc.db" "\\1/configuration/pc.db" "\\1/package/pc.db" "\\1/body/pc.db" downcase))
     ("GHDL" "ghdl" "-i --workdir=\\1 --ieee=synopsys -fexplicit " "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "ghdl"
      ("ghdl_p: \\*E,\\w+ (\\([^ \\t\\n]+\\),\\([0-9]+\\)|\\([0-9]+\\)):" 1 2 3)
      ("" 0)
      ("\\1/entity" "\\2/\\1" "\\1/configuration" "\\1/package" "\\1/body" downcase))
     ("IBM Compiler" "g2tvc" "-src" "precomp" "\\1" nil "mkdir \\1" "./" "work/" "Makefile" "ibm"
      ("[0-9]+ COACHDL.*: File: \\([^ \\t\\n]+\\), line.column: \\([0-9]+\\).\\([0-9]+\\)" 1 2 3)
      (" " 0)
      nil)
     ("Ikos" "analyze" "-l \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "ikos"
      ("E L\\([0-9]+\\)/C\\([0-9]+\\):" nil 1 2)
      ("^analyze +\\(.+ +\\)*\\(.+\\)$" 2)
      nil)
     ("ModelSim" "vcom" "" "make" "-f \\1" nil "vlib \\1; vmap \\2 \\1" "./" "./" "Makefile" "modelsim"
      ("\\(ERROR\\|WARNING\\|\\*\\* Error\\|\\*\\* Warning\\)[^:]*:\\( *[[0-9]+]\\)? \\([^ \\t\\n]+\\)(\\([0-9]+\\)):" 3 4 nil)
      ("" 0)
      ("\\1/_primary.dat" "\\2/\\1.dat" "\\1/_primary.dat" "\\1/_primary.dat" "\\1/body.dat" downcase))
     ("LEDA ProVHDL" "provhdl" "-w \\1 -f" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "provhdl"
      ("\\([^ \\t\\n]+\\):\\([0-9]+\\): " 1 2 nil)
      ("" 0)
      ("ENTI/\\1.vif" "ARCH/\\1-\\2.vif" "CONF/\\1.vif" "PACK/\\1.vif" "BODY/BODY-\\1.vif" upcase))
     ("Quartus" "make" "-work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "quartus"
      ("\\(Error\\|Warning\\): .* \\([^ \\t\\n]+\\)(\\([0-9]+\\))" 2 3 nil)
      ("" 0)
      nil)
     ("QuickHDL" "qvhcom" "-work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "quickhdl"
      ("\\(ERROR\\|WARNING\\)[^:]*: \\([^ \\t\\n]+\\)(\\([0-9]+\\)):" 2 3 nil)
      ("" 0)
      ("\\1/_primary.dat" "\\2/\\1.dat" "\\1/_primary.dat" "\\1/_primary.dat" "\\1/body.dat" downcase))
     ("Savant" "scram" "-publish-cc -design-library-name \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work._savant_lib/" "Makefile" "savant"
      ("\\([^ \\t\\n]+\\):\\([0-9]+\\): " 1 2 nil)
      ("" 0)
      ("\\1_entity.vhdl" "\\2_secondary_units._savant_lib/\\2_\\1.vhdl" "\\1_config.vhdl" "\\1_package.vhdl" "\\1_secondary_units._savant_lib/\\1_package_body.vhdl" downcase))
     ("Simili" "vhdlp" "-work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "simili"
      ("\\(Error\\|Warning\\): \\w+: \\([^ \\t\\n]+\\): (line \\([0-9]+\\)): " 2 3 nil)
      ("" 0)
      ("\\1/prim.var" "\\2/_\\1.var" "\\1/prim.var" "\\1/prim.var" "\\1/_body.var" downcase))
     ("Speedwave" "analyze" "-libfile vsslib.ini -src" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "speedwave"
      ("^ *ERROR[[0-9]+]::File \\([^ \\t\\n]+\\) Line \\([0-9]+\\):" 1 2 nil)
      ("" 0)
      nil)
     ("Synopsys" "vhdlan" "-nc -work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "synopsys"
      ("\\*\\*Error: vhdlan,[0-9]+ \\([^ \\t\\n]+\\)(\\([0-9]+\\)):" 1 2 nil)
      ("" 0)
      ("\\1.sim" "\\2__\\1.sim" "\\1.sim" "\\1.sim" "\\1__.sim" upcase))
     ("Synopsys Design Compiler" "vhdlan" "-nc -spc -work \\1" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "synopsys_dc"
      ("\\*\\*Error: vhdlan,[0-9]+ \\([^ \\t\\n]+\\)(\\([0-9]+\\)):" 1 2 nil)
      ("" 0)
      ("\\1.syn" "\\2__\\1.syn" "\\1.syn" "\\1.syn" "\\1__.syn" upcase))
     ("Synplify" "n/a" "n/a" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "synplify"
      ("@[EWN]:\"\\([^ \\t\\n]+\\)\":\\([0-9]+\\):\\([0-9]+\\):" 1 2 3)
      ("" 0)
      nil)
     ("Vantage" "analyze" "-libfile vsslib.ini -src" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "vantage"
      ("\\*\\*Error: LINE \\([0-9]+\\) \\*\\*\\*" nil 1 nil)
      ("^ *Compiling \"\\(.+\\)\" " 1)
      nil)
     ("VeriBest" "vc" "vhdl" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "veribest"
      ("^ +\\([0-9]+\\): +[^ ]" nil 1 nil)
      ("" 0)
      nil)
     ("Viewlogic" "analyze" "-libfile vsslib.ini -src" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "viewlogic"
      ("\\*\\*Error: LINE \\([0-9]+\\) \\*\\*\\*" nil 1 nil)
      ("^ *Compiling \"\\(.+\\)\" " 1)
      nil)
     ("Xilinx XST" "xflow" "" "make" "-f \\1" nil "mkdir \\1" "./" "work/" "Makefile" "xilinx"
      ("^ERROR:HDLParsers:[0-9]+ - \"\\([^ \\t\\n]+\\)\" Line \\([0-9]+\\)." 1 2 nil)
      ("" 0)
      nil))))
 '(vhdl-testbench-architecture-name (quote (".*" . "testbench")))
 '(vhdl-testbench-declarations "  -- clock
  signal testbench_clk : std_logic := '1';
")
 '(vhdl-testbench-statements
   "  -- clock generation
  testbench_clk <= not testbench_clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    wait until testbench_clk = '1';
  end process WaveGen_Proc;
"))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
