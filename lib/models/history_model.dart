class HistoryModel {
  String? total;
  int? page;
  String? cursor;
  int? pageSize;
  List<Result>? result;

  HistoryModel(
      {this.total, this.page, this.cursor, this.pageSize, this.result});

  HistoryModel.fromJson(Map<String, dynamic> json, String _chain) {
    total = json['total'];
    page = json['page'];
    cursor = json['cursor'];
    pageSize = json['page_size'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v, _chain));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['cursor'] = cursor;
    data['page_size'] = pageSize;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? hash;
  String? nonce;
  String? transactionIndex;
  String? fromAddress;
  String? toAddress;
  String? value;
  String? gas;
  String? gasPrice;
  String? input;
  String? receiptCumulativeGasUsed;
  String? receiptGasUsed;
  String? receiptContractAddress;
  String? receiptRoot;
  String? receiptStatus;
  String? blockTimestamp;
  String? blockNumber;
  String? blockHash;
  String? internalTransactions;
  String? chain;

  Result({
    this.hash,
    this.nonce,
    this.transactionIndex,
    this.fromAddress,
    this.toAddress,
    this.value,
    this.gas,
    this.gasPrice,
    this.input,
    this.receiptCumulativeGasUsed,
    this.receiptGasUsed,
    this.receiptContractAddress,
    this.receiptRoot,
    this.receiptStatus,
    this.blockTimestamp,
    this.blockNumber,
    this.blockHash,
    this.internalTransactions,
    this.chain,
  });

  Result.fromJson(Map<String, dynamic> json, String _chain) {
    chain = _chain;
    hash = json['hash'];
    nonce = json['nonce'];
    transactionIndex = json['transaction_index'];
    fromAddress = json['from_address'];
    toAddress = json['to_address'];
    value = json['value'];
    gas = json['gas'];
    gasPrice = json['gas_price'];
    input = json['input'];
    receiptCumulativeGasUsed = json['receipt_cumulative_gas_used'];
    receiptGasUsed = json['receipt_gas_used'];
    receiptContractAddress = json['receipt_contract_address'];
    receiptRoot = json['receipt_root'];
    receiptStatus = json['receipt_status'];
    blockTimestamp = json['block_timestamp'];
    blockNumber = json['block_number'];
    blockHash = json['block_hash'];
    internalTransactions = json['internal_transactions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash'] = hash;
    data['nonce'] = nonce;
    data['transaction_index'] = transactionIndex;
    data['from_address'] = fromAddress;
    data['to_address'] = toAddress;
    data['value'] = value;
    data['gas'] = gas;
    data['gas_price'] = gasPrice;
    data['input'] = input;
    data['receipt_cumulative_gas_used'] = receiptCumulativeGasUsed;
    data['receipt_gas_used'] = receiptGasUsed;
    data['receipt_contract_address'] = receiptContractAddress;
    data['receipt_root'] = receiptRoot;
    data['receipt_status'] = receiptStatus;
    data['block_timestamp'] = blockTimestamp;
    data['block_number'] = blockNumber;
    data['block_hash'] = blockHash;
    data['internal_transactions'] = internalTransactions;
    data['chain'] = chain;
    return data;
  }
}
