<?php
/**
 * This is a sample PHP script of SVM (Support Vector Machine).
 *
 * - See:
 *    - https://www.php.net/manual/en/book.svm.php
 *    - https://www.php.net/manual/en/svm.examples.php
 * - Train Data Format: (See https://github.com/cjlin1/libsvm)
 *     <label> <index1>:<value1> <index2>:<value2> ...
 *     .
 *     .
 *     .
 */

/**
 * Train from an array.
 */
echo '- Training data via array and predict ...' . PHP_EOL;
// Train Data
$data = array(
    array(-1, 1 => 0.43, 3 => 0.12, 9284 => 0.2),
    array(1, 1 => 0.22, 5 => 0.01, 94 => 0.11),
);
// Instantiate SVM
$svm = new SVM();
// Train from array data
$model = $svm->train($data);
// Predict
$data = array(1 => 0.43, 3 => 0.12, 9284 => 0.2);
// Dump result
$result = $model->predict($data);
var_dump($result); // Expect float(-1)
// Save trained model
$model->save('models/model1.svm');

/**
 * Train from a file.
 */
echo '- Training data via file and predict ...' . PHP_EOL;
// Train Data
$path_file_data = 'traindata.txt';
// Instantiate SVM
$svm = new SVM();
// Train from data file
$model = $svm->train($path_file_data);
// Predict
$data = [
    1 => 0.43,
    3 => 0.12,
    9284 => 0.2
];
// Dump result
$result = $model->predict($data);
var_dump($result); // Expect float(-1)
// Save trained model
$model->save('models/model2.svm');

/**
 * Predict from a trained model.
 */
echo '- Predict from trained data (model) file ...' . PHP_EOL;
// Trained Data (Model)
$path_file_model = 'models/model1.svm';
// Instantiate SVMModel from the trained model
$model = new SVMModel($path_file_model);
// Predict
$data = array(1 => 0.43, 3 => 0.12, 9284 => 0.2);
// Dump result
$result = $model->predict($data);
var_dump($result); // Expect float(-1)
