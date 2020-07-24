local template = import 'template.libsonnet';

// BERTDatasetReader
local bert_model = 'bert-large-cased';
local max_length = 512;

// LSTMEncoder
local bert_embedding_dim = 1024;
local lstm_bidirectional = true;
local lstm_num_layers = 2;
local lstm_hidden_size = 768;
local lstm_dropout = 0.0;

// Trainer
local optimizer = 'adam';
local lr = 5e-7;
local num_epochs = 150;
local cuda_device = 0;


{
  dataset_reader: template.BERTDatasetReader(bert_model, max_length),
  datasets_for_vocab_creation: ['train'],
  train_data_path: './data/eng.train',
  validation_data_path: './data/eng.testa',
  test_data_path: './data/eng.testb',
  evaluate_on_test: true,
  model: {
    type: 'simple_tagger_2',
    label_encoding: 'BIOUL',
    calculate_span_f1: true,
    text_field_embedder: {
      token_embedders: {
        tokens: {
          type: 'pretrained_transformer_mismatched',
          model_name: bert_model,
          max_length: max_length,
        },
      },
    },
    encoder: template.LSTMEncoder(
      bert_embedding_dim,
      lstm_hidden_size,
      lstm_num_layers,
      lstm_bidirectional,
      lstm_dropout,
    ),
  },
  data_loader: {
    batch_size: 10,
  },
  trainer: template.Trainer(
    optimizer,
    lr,
    num_epochs,
    cuda_device,
  ),
}
