on run {input, parameters}
    -- パスを受け取る
    try
        set filePath to POSIX path of input
    on error errMsg
        set filePath to ""
    end try

    -- Alacrittyでnvimを開く
    if filePath is "" then
        do shell script "/usr/local/bin/alacritty --title Nvim.app -e /usr/local/bin/nvim"
    else
        do shell script "/usr/local/bin/alacritty --title Nvim.app -e /usr/local/bin/nvim " & quoted form of filePath
    end if
end run

