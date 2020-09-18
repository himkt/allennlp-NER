local template = import 'template.libsonnet';

// Embedding
local embedding_dim = 100;
local pretrained_file = 'https://allennlp.s3.amazonaws.com/datasets/glove/glove.6B.100d.txt.gz';

// CNNEncoder
local char_embedding_dim = std.parseInt(std.extVar('char_embedding_dim'));
local cnn_num_filters = 30;
local cnn_windows = [3];

// LSTMEncoder
local lstm_input_size = embedding_dim + cnn_num_filters;
local lstm_hidden_size = std.parseInt(std.extVar('lstm_hidden_size'));
local lstm_num_layers = 1;
local lstm_bidirectional = true;
local lstm_dropout = 0.5;

// Trainer
local optimizer = 'sgd';
local lr = std.parseJson(std.extVar('lr'));
local num_epochs = 50;
local cuda_device = 0;


{
  dataset_reader: template.NormalDatasetReader(),
  datasets_for_vocab_creation: ['train'],
  train_data_path: './data/eng.train',
  validation_data_path: './data/eng.testa',
  test_data_path: './data/eng.testb',
  evaluate_on_test: true,
  model: {
    type: 'crf_tagger',
    label_encoding: 'BIOUL',
    constrain_crf_decoding: true,
    calculate_span_f1: true,
    dropout: 0.5,
    include_start_end_transitions: false,
    text_field_embedder: {
      token_embedders: {
        tokens: template.Embedding(
          embedding_dim,
          pretrained_file,
        ),
        token_characters: {
          type: 'character_encoding',
          embedding: {
            embedding_dim: char_embedding_dim,
          },
          encoder: template.CNNEncoder(
            char_embedding_dim,
            cnn_num_filters,
            cnn_windows
          ),
        },
      },
    },
    encoder: template.LSTMEncoder(
      lstm_input_size,
      lstm_hidden_size,
      lstm_num_layers,
      lstm_bidirectional,
      lstm_dropout,
    ),
  },
  data_loader: {
    batch_size: 10,
  },
  trainer: template.OptunaTrainer(
    optimizer,
    lr,
    num_epochs,
    cuda_device
  ),
}
