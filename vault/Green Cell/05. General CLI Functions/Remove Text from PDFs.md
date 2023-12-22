
### Linux
---

```shell
# Uncompress PDF
pdftk <original_file>.pdf output <uncompressed_file>.pdf uncompress

# Edit Uncompressed PDF with a text editor
sed -e "s/watermarktextstring/ /" <uncompressed_file>.pdf > <uncompressed_edited>.pdf

# Recompress PDF
pdftk <uncompressed_edited>.pdf output <new_file>.pdf compress
```
