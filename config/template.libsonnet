{
  BERTDatasetReader:: function(bert_model, max_length) {
    type: 'conll2003',
    tag_label: 'ner',
    coding_scheme: 'BIOUL',
    token_indexers: {
      tokens: {
        type: 'pretrained_transformer_mismatched',
        model_name: bert_model,
        max_length: max_length,
      },
    },
  },

  NormalDatasetReader:: function() {
    type: 'conll2003',
    tag_label: 'ner',
    coding_scheme: 'BIOUL',
    token_indexers: {
      tokens: {
        type: 'single_id',
        lowercase_tokens: true,
      },
      token_characters: {
        type: 'characters',
        min_padding_length: 3,
      },
    },
  },

  Embedding:: function(embedding_dim, pretrained_file=null) {
    type: 'embedding',
    embedding_dim: embedding_dim,
    pretrained_file: pretrained_file,
    trainable: true,
  },

  LSTMEncoder:: function(input_size, hidden_size, num_layers, bidirectional, dropout) {
    type: 'lstm',
    input_size: input_size,
    hidden_size: hidden_size,
    bidirectional: bidirectional,
    num_layers: num_layers,
    dropout: dropout,
  },

  CNNEncoder:: function(embedding_dim, num_filters, windows) {
    type: 'cnn',
    embedding_dim: embedding_dim,
    num_filters: num_filters,
    ngram_filter_sizes: windows,
    conv_layer_activation: 'relu',
  },

  Trainer:: function(optimizer, lr, num_epochs, cuda_device) {
    optimizer: {
      type: optimizer,
      lr: lr,
    },
    checkpointer: {
      num_serialized_models_to_keep: 3,
    },
    validation_metric: '+f1-measure-overall',
    num_epochs: num_epochs,
    patience: 25,
    cuda_device: cuda_device,
  },
}
