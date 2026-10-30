The patches should implement the spec described here.

## 0001-launchpad-scene-buttons-track-navigation.patch

Adds a Launchpad "Scene 1/2 buttons" setting. The buttons can either change the
scale layout as before or select the previous/next track. Track navigation is
enabled by default. When active, the button LEDs use the color of the track that
would be selected. Adds the necessary track-color lookup to the track bank
implementations.

## 0002-drum-view-selected-pad-highlight-toggle.patch

Adds a "Highlight selected drum pad" option. It is disabled by default, so drum
views keep the selected pad's normal state color unless highlighting is
explicitly enabled.
