# AllenNLP NER: AllenNLP Models for Named Entity Recognition

## Installation

AllenNLP NER uses `poetry` for library management.
If you don't have `poetry`, please run `pip3 install poetry`.

```
git clone git@github.com:himkt/allennlp_ner && cd allennlp_ner
poetry install
```

## Run model training

```
poetry run allennlp train config/bert.jsonnet --include-pacakge allennlp_ner -s model/bert
poetry run allennlp train config/bert-crf.jsonnet -s model/bert-crf
poetry run allennlp train config/bilstm-crf.jsonnet -s model/bilstm-crf
poetry run allennlp train config/bilstm-cnn-crf.jsonnet -s model/bilstm-cnn-crf
```

## [New!] Hyperparameter Optimization

You can try hyperparameter optimization for BiLSTM-CNN-CRF!
It uses [Optuna](https://github.com/optuna/optuna), please read [AllenNLP guide](https://guide.allennlp.org/hyperparameter-optimization) if you want to learn more.

```
poetry run python hpo.py
```

Or, you can also use [`allennlp-optuna`](https://github.com/himkt/allennlp-optuna).

```
poetry run allennlp tune \
  config/bilstm-cnn-crf-hpo.jsonnet  \
  config/bilstm-cnn-crf.hparams.json \
  --serialization-dir result \
  --metrics best_validation_f1-measure-overall \
  --direction maximize
```



## References

- [BiLSTM-CRF](./config/bilstm-crf.jsonnet) [Lample+, NAACL2016]: https://www.aclweb.org/anthology/N16-1030/
- [BiLSTM-CNN-CRF](./config/bilstm-cnn-crf.jsonnet) [Ma+, ACL2016]: https://www.aclweb.org/anthology/P16-1101/
- [BERT](./config/bert.jsonnet) [Devlin+, NAACL2019]: https://www.aclweb.org/anthology/N19-1423/
- [BERT-CRF](./config/bert-crf.jsonnet) [Devlin+, NAACL2019]: https://www.aclweb.org/anthology/N19-1423/ + CRF
