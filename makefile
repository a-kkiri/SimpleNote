.PHONY: watch compile

ifeq ($(OS),Windows_NT)
    # Windows
    watch:
		@PowerShell -Command "typst watch --font-path ./fonts main.typ --root ."

    compile:
		@PowerShell -Command "typst compile --font-path ./fonts main.typ"
else
    # WSL or Unix-like system
    watch:
		@bash -c "typst watch --font-path ./fonts main.typ --root ."

    compile:
		@bash -c "typst compile --font-path ./fonts main.typ"
endif
