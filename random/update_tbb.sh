#!/bin/bash

newv=$(wget https://www.torproject.org/download/download.html.en -O - | grep -oP '\d+\.\d+\.\d+\/tor-browser-linux64-\d+\.\d+\.\d+_en-US.tar.xz' | head -1)
# => 7.5.5/tor-browser-linux64-7.5.5_en-US.tar.xz
url="https://www.torproject.org/dist/torbrowser/$newv"

echo "[+] Using $url, ok?"
read a

#if [[ -z "$1" ]]
#then
#  echo "Usage: $0 <dest path>"
#  echo "e.g. $0 https://www.torproject.org/dist/torbrowser/7.0.2/tor-browser-linux64-7.0.2_en-US.tar.xz"
#  exit 1
#fi

filename=$(echo "$url" | grep -oP "tor-browser-linux64-.*\.tar\.xz")
if [[ -z "$filename" ]]
then
  echo "[!] Could not extract filename from input $url"
  exit 2
fi
echo "[+] Using filename $filename"

version=$(echo "$filename" | sed 's/tor-browser-linux64-//' | sed 's/_en-US.tar.xz//')
if [[ -z "$version" ]]
then
  echo "[!] Could not extract version from filename $filename"
  exit 3
fi
echo "[+] Using version $version"

cd "$1"
mkdir "tbb-$version"
cd "tbb-$version"

if [[ ! -e "$filename" ]]
then
  wget "$url"
else
  echo "[+] $filename already exists, delete it to redownload."
fi

if [[ ! -e "$filename" ]]
then
  echo "[!] Failed to download $filename from $url"
  exit 4
fi

if [[ ! -e "$filename".asc ]]
then
  wget "$url".asc
else
  echo "[+] $filename.asc already exists, delete it to redownload."
fi

if [[ ! -e "$filename".asc ]]
then
  echo "[!] Failed to download $filename.asc from $url.asc (is Tor running?)"
  exit 5
fi

gpg --verify "$filename"{.asc,}

echo "OK? (ctrl-c to quit)"
read a

if [[ ! -e tor-browser_en-US ]]
then
  tar xvJf "$filename"
else
  echo "[+] directory tor-browser_en-US already exists, delete it to reextract"
fi

> start_torbrowser.sh
echo 'cd ./tor-browser_en-US/Browser/' >> start_torbrowser.sh
echo 'LD_LIBRARY_PATH=. ./firefox' >> start_torbrowser.sh
chmod a+x start_torbrowser.sh

# XXX breaks tbb8
#find tor-browser_en-US/Browser -iname "*.so*" -exec mv {} tor-browser_en-US/Browser \;

rm -r tor-browser_en-US/Browser/TorBrowser/Tor/
rm -r tor-browser_en-US/Browser/TorBrowser/Docs/
rm tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default/extensions/tor-launcher@torproject.org.xpi
rm tor-browser_en-US/Browser/update*

cd ..

echo "[+] Copying prefs.js from old profile..."
old_prefs_path="tbb-latest/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default/prefs.js"
new_prefs_path="tbb-$version/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default/prefs.js"
echo "    $old_prefs_path --> $new_prefs_path"
cp "$old_prefs_path" "$new_prefs_path"

rm tbb-latest
ln -sf "tbb-$version" tbb-latest
echo "[+] All good kthxbai ^_^d"
