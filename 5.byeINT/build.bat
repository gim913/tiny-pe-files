@IF EXIST target\ (
  nasm -f bin -o target/noint.exe -l noint.lst 5.byeINT/noint.asm
  IF EXIST target/noint.exe (
    echo compiled noint.exe
  ) ELSE (
    echo Compilation failed inside 5.byeINT directory
  )
) ELSE (
  echo Run top-level directory build instead
)
