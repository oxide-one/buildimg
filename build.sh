echo "Features: $2"
echo "Flavors: $1"
for flavor in $1; do
echo "#### BUILDING FLAVOR $flavor ####"
export MKINITFS_ARGS="-i $PWD/initramfs-init"
update-kernel \
          --media \
          --flavor "$flavor" \
          --arch "$(cat /etc/apk/arch)" \
	  -F "$2" \
          --repositories-file /tmp/repositories \
          /build/$(cat /etc/apk/arch) \

done
