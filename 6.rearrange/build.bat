@IF EXIST target\ (
  nasm -f bin -o target/tetris.exe -l tetris.lst 6.rearrange/tetris.asm
  IF EXIST target/tetris.exe (
    echo compiled tetris.exe
  ) ELSE (
    echo Compilation failed inside 6.rearrange directory
  )
) ELSE (
  echo Run top-level directory build instead
)
