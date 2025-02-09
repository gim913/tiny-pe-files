@IF EXIST target\ (
  nasm -f bin -o target/nodd.exe -l nodd.lst 2.drop-dds/nodd.asm
  IF EXIST target/nodd.exe (
    echo compiled nodd.exe
  ) ELSE (
    echo Compilation failed inside 2.drop-dds directory
  )
) ELSE (
  echo Run top-level directory build instead
)
