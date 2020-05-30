# AllenNLP NER - AllenNLP Models for Named Entity Recognition

### Installation

AllenNLP NER uses `poetry` for library management.
If you don't have `poetry`, please run `pip3 install poetry`.

```
git clone git@github.com:himkt/allennlp_ner && cd allennlp_ner
poetry install
```

### Models

- [BiLSTM-CNN-CRF](./config/bilstm-cnn-crf.jsonnet) [Ma+, 2016]
  - https://www.aclweb.org/anthology/P16-1101/
- [BERT](./config/bert.jsonnet)
- [BERT-LSTM](./config/bert-lstm.jsonnet)
- [BERT-CRF](./config/bert-crf.jsonnet)
- [BERT-LSTM-CRF](./config/bert-lstm-crf.jsonnet)

### Modules

- `SimpleTagger2`
  - Will be removed after https://github.com/allenai/allennlp/pull/4302 is merged.
- `span_f1_2`
  - https://github.com/allenai/allennlp/pull/4302#issuecomment-636237398
