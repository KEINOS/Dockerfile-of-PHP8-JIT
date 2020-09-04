# Sample Usage of Support Vector Machine (SVM) in PHP8

```text
.
├── Dockerfile      # Dockerfile
├── README.md       # This file
├── sample.php      # Sample PHP script
└── traindata.txt   # Sample data to train
```

```shellsession
$ # Build the image
$ docker build -t svm:test .
...

$ # Run the PHP script in the container
$ docker run --rm svm:test
- Training data via array and predict ...
float(-1)
- Training data via file and predict ...
float(-1)
- Predict from trained data (model) file ...
float(-1)
```

## References

- How to install `libsvm` in Docker Alpine: https://github.com/smizy/docker-libsvm @ GitHub
- `libsvm` Source: https://github.com/cjlin1/libsvm by [cjlin1](http://www.csie.ntu.edu.tw/~cjlin/libsvm) @ GitHub
- Sample to use PHP `svm` extension: https://www.php.net/manual/en/svm.examples.php @ PHP Manual
