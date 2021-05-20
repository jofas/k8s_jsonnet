for file in tests/*.jsonnet; do
  res=${file%.*}.yml
  echo "$(kubecfg show $file)" | diff $res -
done
