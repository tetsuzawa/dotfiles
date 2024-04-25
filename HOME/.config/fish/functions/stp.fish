function stp
    python3 -c "import sys; print(''.join(word.capitalize() for word in sys.stdin.read().strip().replace('-', '_').split('_')), end='')"
end
