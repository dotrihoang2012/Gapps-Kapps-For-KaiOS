import zipfile, os, sys

def rebuild_zip(app_dir, zip_path):
    os.makedirs(os.path.dirname(zip_path), exist_ok=True)
    if os.path.exists(zip_path):
        os.remove(zip_path)
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(app_dir):
            for fn in files:
                full = os.path.join(root, fn)
                rel = os.path.relpath(full, app_dir).replace('\\\\', '/').replace('\\', '/')
                zf.write(full, rel)
    return os.path.getsize(zip_path) / (1024*1024)

base = r"C:\\Users\\hoang\\Downloads\\desktop\\Gapps-Kapps-For-KaiOS"
methods = ["Method 2 - slideload", "Method 3 - Slideload and System", "Method 4 - System App - Both Json"]
count = 0
for cat in ["Gapps", "Kapps"]:
    not_zip_root = os.path.join(base, cat, "OTA Update", "Not Zip")
    unsign_root = os.path.join(base, cat, "OTA Update", "Zip but unsign")
    for method in methods:
        method_path = os.path.join(not_zip_root, method)
        unsign_method = os.path.join(unsign_root, method)
        if not os.path.isdir(method_path):
            continue
        os.makedirs(unsign_method, exist_ok=True)
        for variant in os.listdir(method_path):
            app_dir = os.path.join(method_path, variant)
            if not os.path.isdir(app_dir):
                continue
            zip_file = os.path.join(unsign_method, variant + ".zip")
            size = rebuild_zip(app_dir, zip_file)
            print(f"OK  {cat} : {method} / {variant}.zip  ({size:.1f} MB)")
            count += 1
print(f"\nTotal zips rebuilt: {count}")
