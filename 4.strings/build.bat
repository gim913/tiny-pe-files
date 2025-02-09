@IF EXIST target\ (
  nasm -f bin -o target/strings.exe -l strings.lst 4.strings/strings.asm
  IF EXIST target/strings.exe (
    echo compiled strings.exe
  ) ELSE (
    echo Compilation failed inside 4.strings directory
  )
) ELSE (
  echo Run top-level directory build instead
)
