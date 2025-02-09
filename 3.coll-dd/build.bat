@IF EXIST target\ (
  nasm -f bin -o target/cold.exe -l cold.lst 3.coll-dd/cold.asm
  IF EXIST target/cold.exe (
    echo compiled cold.exe
  ) ELSE (
    echo Compilation failed inside 3.col-dd directory
  )
) ELSE (
  echo Run top-level directory build instead
)
