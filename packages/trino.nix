{
  stdenvNoCC,
  makeWrapper,
  fetchurl,
  lib,
  openjdk25_headless,
  minimal ? false,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "trino-server";
  version = "480";
  src =
    if minimal then
      (fetchurl {
        url = "https://github.com/trinodb/trino/releases/download/${finalAttrs.version}/trino-server-core-${finalAttrs.version}.tar.gz";
        sha256 = "sha256-qGj/k5PNCpk7C7evQgvS+NYrgzUXFq/6SnRrfBfAOQo=";
      })
    else
      (fetchurl {
        url = "https://github.com/trinodb/trino/releases/download/${finalAttrs.version}/trino-server-${finalAttrs.version}.tar.gz";
        sha256 = "sha256-wzHOHwvVWxoSVLVyRlDP4tHpSCi4liX97NS12K+7CiU=";
      });

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mv {lib,plugin,secrets-plugin} $out
    mv bin/{linux-amd64,launcher.properties} $out/bin/
    makeWrapper $out/bin/linux-amd64/launcher $out/bin/launcher \
      --add-flags "-jvm-dir ${openjdk25_headless}"
  '';
  meta.mainProgram = "launcher";
})
