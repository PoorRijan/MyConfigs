function gitup
    git add .
    git commit -a -m "$argv[1]"
    git push
end
