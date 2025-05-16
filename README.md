To clone the repo:

```bash
git clone --recurse-submodules https://github.com/Dragan14/rn-fundamentals.git
```

In /demo/tsconfig.json configure the path.

```json
"paths": {
  "@/*": ["../cli/./*"]
}
```
