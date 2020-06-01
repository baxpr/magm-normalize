# magm-normalize

Computes a gray matter image from MultiAtlas output, and warps it to MNI space. It is a two-step process: first a rigid-body registration with SPM12 "Coreg" to initialize, then a nonlinear warp with SPM12 "Old Normalise". Outputs are the two transforms; and the T1, gray matter, and MultiAtlas segmentation images after each transform is applied.
