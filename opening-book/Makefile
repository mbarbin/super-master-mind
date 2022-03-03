.PHONY: opening-book
opening-book:
	opam exec -- dune exec super-master-mind -- opening-book compute --depth 2 | tee /tmp/opening-book.expected
	mv /tmp/opening-book.expected opening-book.expected
