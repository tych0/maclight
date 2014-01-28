PREFIX=/usr/local

BIN=dist/build/maclight/maclight

$(BIN): src
	@cabal configure
	@cabal build

.PHONY: install
install:
	@install -Dm 4755 $(BIN) $(PREFIX)/bin/maclight

uninstall:
	@rm -f $(PREFIX)/bin/maclight

clean:
	-@cabal clean
