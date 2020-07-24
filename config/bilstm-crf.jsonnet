local template = import 'template.libsonnet';

// Global
local char_embedding_dim = 25;
local dropout = 0.5;

// Embedding
local embedding_dim = 100;
local pretrained_file = 'https://allennlp.s3.amazonaws.com/datasets/glove/glove.6B.100d.txt.gz';

// LSTMEncoder
local char_lstm_input_size = char_embedding_dim;
local char_lstm_hidden_size = 25;
local char_lstm_num_layers = 1;
local char_lstm_bidirectional = true;
local char_lstm_dropout = dropout;

// LSTMEncoder
local lstm_input_size = embedding_dim + 2 * char_lstm_hidden_size;
local lstm_hidden_size = 200;
local lstm_num_layers = 1;
local lstm_bidirectional = true;
local lstm_dropout = dropout;

// Trainer
local optimizer = 'sgd';
local lr = 0.015;
local num_epochs = 150;
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
    dropout: dropout,
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
          encoder: template.LSTMEncoder(
            char_lstm_input_size,
            char_lstm_hidden_size,
            char_lstm_num_layers,
            char_lstm_bidirectional,
            char_lstm_dropout,
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
  trainer: template.Trainer(
    optimizer,
    lr,
    num_epochs,
    cuda_device
  ),
}
