# keyValueGUI
Key-value pairs

Browse and add structured annotations to images in an OMERO server. Initially designed for members of read-write or read-annotate groups, the purpose is to keep a consistent nomenclature for extra-imaging metadata annotation of images.

A strict Project -> Dataset -> Image hierarchy is required. Users can then add map annotations to their own images, as well as those of their peers.

On launch, previous key/value pairs associated with images in the group will be loaded into a dictionary for the user to select, minimising the chance of typos ruining a nomenclature. 

New key/value pairs can be created and these will be checked against the current dictionary. New values can be added to an existing key.

The user builds up a table of key/value pairs and can then save this to the server to multiple images at the same time, regardless of who owns the images.

Map annotations previously saved to images can be viewed and the contents copied to the table for ease.
