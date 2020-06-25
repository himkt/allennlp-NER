# AllenNLP NER - AllenNLP Models for Named Entity Recognition

### Installation

AllenNLP NER uses `poetry` for library management.
If you don't have `poetry`, please run `pip3 install poetry`.

```
git clone git@github.com:himkt/allennlp_ner && cd allennlp_ner
poetry install
```

### Models

- [BiLSTM-CRF](./config/bilstm-crf.jsonnet) [Lample+, 2016]
  - NAACL2016, https://www.aclweb.org/anthology/N16-1030/
- [BiLSTM-CNN-CRF](./config/bilstm-cnn-crf.jsonnet) [Ma+, 2016]
  - ACL2016, https://www.aclweb.org/anthology/P16-1101/
- [BERT](./config/bert.jsonnet) [Devlin+, 2019]
  - NAACL2019, https://www.aclweb.org/anthology/N19-1423/

### Modules

- `SimpleTagger2`
- `span_f1_2`
