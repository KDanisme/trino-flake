{
  writeText,
  linkFarmFromDrvs,
  writeShellScriptBin,
  lib,
  trino,
  port ? 8080,
  ...
}:
let
  config = writeText "config.properties" ''
    coordinator=true
    node-scheduler.include-coordinator=true
    http-server.http.port=${toString port}
    discovery.uri=http://localhost:${toString port}
    catalog.management=dynamic
    catalog.store=memory
  '';
  jvmConfig = writeText "node.properties" ''
    node.environment=production
    node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
  '';
  nodeConfig = writeText "jvm.config" ''
    -server
    -Xmx4G
    -XX:InitialRAMPercentage=80
    -XX:MaxRAMPercentage=80
    -XX:G1HeapRegionSize=32M
    -XX:+ExplicitGCInvokesConcurrent
    -XX:+ExitOnOutOfMemoryError
    -XX:+HeapDumpOnOutOfMemoryError
    -XX:-OmitStackTraceInFastThrow
    -XX:ReservedCodeCacheSize=512M
    -XX:PerMethodRecompilationCutoff=10000
    -XX:PerBytecodeRecompilationCutoff=10000
    -Djdk.attach.allowAttachSelf=true
    -Djdk.nio.maxCachedBufferSize=2000000
  '';
  etc = linkFarmFromDrvs "etc" [
    config
    jvmConfig
    nodeConfig
  ];
in
writeShellScriptBin "trino-basic" ''
  exec ${lib.getExe trino}  \
  -etc-dir ${etc} \
  "$@"
''
