cleanup() {
    rm wp-content/plugins/post-deploy.sh
}
trap cleanup EXIT

# Get the the new plugin version
AFTER_PLUGIN_VERSION=$(wp plugin get test-plugin | sed -n "/version/p" | cut -f2)
echo "New test plugin version: $AFTER_PLUGIN_VERSION"

# Revert to backup created by rsync
rm -rf wp-content/plugins/test-plugin && mv /tmp/test-plugin wp-content/plugins/

# Get the old plugin version
BEFORE_PLUGIN_VERSION=$(wp plugin get test-plugin | sed -n "/version/p" | cut -f2)
echo "Old test plugin version: $BEFORE_PLUGIN_VERSION"

# Check that the expected update was made
if [ "$BEFORE_PLUGIN_VERSION" = "$AFTER_PLUGIN_VERSION" ]; then
    echo "Failure: Test plugin was not updated!" && exit 1
else
    echo "Success: Test plugin successfully updated from $BEFORE_PLUGIN_VERSION to $AFTER_PLUGIN_VERSION!"
fi
