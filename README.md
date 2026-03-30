# Trino Flake

## Outputs

- `trino`: which is trino wrapped with the airlift launcher
- `trino-basic`: which is a preconfigured standalone instance of trino where the only required configuration is `-data-dir`

> [!NOTE]
> there are `-minimal` variants of both of these packages which uses the "core" tarball variant of trino, which includes only the required plugins

## Example

To run trino in a basic single node configuration:

```bash
nix run github:kdanisme/trino-flake#trino-basic -- -data-dir ./data run
```

## Configuration

To configuration trino you can look at the [flake](./flake.nix) for inspiration
