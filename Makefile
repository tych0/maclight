PREFIX=/usr/local

BIN=dist/build/maclight/maclight

$(BIN): src
	@cabal configure --enable-tests
	@cabal build

.PHONY: test
test:
	cabal build
	cabal test

.PHONY: install
install: $(BIN)
	@install -Dm 4755 $(BIN) $(PREFIX)/bin/maclight

uninstall:
	@rm -f $(PREFIX)/bin/maclight

clean:
	-@cabal clean
