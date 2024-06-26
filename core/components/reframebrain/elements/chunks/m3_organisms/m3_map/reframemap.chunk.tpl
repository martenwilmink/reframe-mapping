<div id="[[+map_id:default=`map-[[+unique_idx]]`]]" class="map"></div>

<script>
    window.addEventListener('DOMContentLoaded', function() {
        const attribution = 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap<\/a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA<\/a>, Imagery &copy; <a href="https://www.mapbox.com/">Mapbox<\/a>';

        // Load tile layers
        const tilesTerrain = L.tileLayer('https://api.mapbox.com/styles/v1/{username}/{id}/tiles/{z}/{x}/{y}{r}?access_token={accessToken}', {
            attribution: attribution,
            tileSize: 512,
            zoomOffset: -1,
            maxZoom: [[+zoom_level_max]],
            id: '[[++earthbrain.mapbox_style_terrain_id]]',
            username: '[[++earthbrain.mapbox_username]]',
            accessToken: '[[++earthbrain.mapbox_access_token]]'
        });
        const tilesSatellite = L.tileLayer('https://api.mapbox.com/styles/v1/{username}/{id}/tiles/{z}/{x}/{y}{r}?access_token={accessToken}', {
            attribution: attribution,
            tileSize: 512,
            zoomOffset: -1,
            maxZoom: [[+zoom_level_max]],
            id: '[[++earthbrain.mapbox_style_satellite_id]]',
            username: '[[++earthbrain.mapbox_username]]',
            accessToken: '[[++earthbrain.mapbox_access_token]]'
        });

        // Prepare popup content
        function addPopup(feature, layerinfo) {
            let popupContent;

            if (feature.properties && feature.properties.popupContent) {
                popupContent = feature.properties.popupContent;
            } else {
                popupContent = feature.properties.name;
            }

            layerinfo.bindPopup(popupContent, {
                closeButton: true
            });

            if (feature.properties.id) {
                markersById[feature.properties.id] = layerinfo;
            }
        }

        const tileLayers = {
            [[+base_layers:contains=`Terrain`:then=`"Terrain": tilesTerrain,`]]
            [[+base_layers:contains=`Satellite`:then=`"Satellite": tilesSatellite`]]
        }

        let mapLayers = {};
        let primaryLayer = '';
        let markersById = [];

        // Load map
        const map = new L.Map('[[+map_id]]', {
            scrollWheelZoom: false,
            layers: [tiles[[+default_layer]]]
        });

        // Load layers with GeoJSON data
        [[+rows]]

        // Add selector to switch between layers
        L.control.layers(tileLayers, mapLayers).addTo(map);

        // Adjust map boundaries to first layer
        map.fitBounds(primaryLayer.getBounds(), {
            padding: [50, 50]
        });

        // Only activate mousewheel scrolling on focus
        map.on('focus', function () {
            map.scrollWheelZoom.enable();
        });
        map.on('blur', function () {
            map.scrollWheelZoom.disable();
        });
    });
</script>