@IF EXIST target\ (
  nasm -f bin -o target/smol.exe -l smol.lst 1.simple/smol.asm
  IF EXIST target/smol.exe (
    echo compiled smoll.exe
  ) ELSE (
    echo Compilation failed inside 1.simple directory
  )
) ELSE (
  echo Run top-level directory build instead & goto EOF
)

:CHECK


:EOF
