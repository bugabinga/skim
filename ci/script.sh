# This script takes care of testing
set -ex

main() {
    cross build --target $TARGET --release

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    cargo test --verbose

    case $TARGET in
        x86_64-unknown-linux-gnu|i686-unknown-linux-gnu)
            # run the integration test
            tmux new "python3.6 test/test_skim.py > out && touch ok" && cat out && [ -e ok ]
            ;;
        x86_64-apple-darwin|i686-apple-darwin)
            # run the integration test
            tmux new "python3 test/test_skim.py > out && touch ok" && cat out && [ -e ok ]
            ;;
        *)
            ;;
    esac
}

if [ -z $TRAVIS_TAG ]; then
    main
fi
