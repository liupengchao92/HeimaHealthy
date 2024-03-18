import { ColumnInfo, ColumnType } from '../common/bean/ColumnInfo'
import RecordPO from '../common/bean/RecordPO'
import DbUtil from '../common/utils/DbUtil'
import relationalStore from '@ohos.data.relationalStore';

// 表名
const TABLE_NAME = 'record'
const ID_COLUMN = 'id'
const TYPE_ID_COLUMN = 'type_id'
const ITEM_ID_COLUMN = 'item_id'
const AMOUNT_COLUMN = 'amount'
const DATE_COLUMN = 'create_time'
// 建表语句
const CREATE_TABLE_SQL: string = `
    CREATE TABLE IF NOT EXISTS ${TABLE_NAME}(
    ${ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TYPE_ID_COLUMN} INTEGER NOT NULL,
    ${ITEM_ID_COLUMN} INTEGER NOT NULL,
    ${AMOUNT_COLUMN} DOUBLE NOT NULL,
    ${DATE_COLUMN} INTEGER NOT NULL
)`


const COLUMNS: ColumnInfo[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  { name: 'typeId', columnName: 'type_id', type: ColumnType.LONG },
  { name: 'itemId', columnName: 'item_id', type: ColumnType.LONG },
  { name: 'amount', columnName: 'amount', type: ColumnType.DOUBLE },
  { name: 'createTime', columnName: 'create_time', type: ColumnType.LONG }
]

class RecordModel {

  // 创建表
  createTable(): Promise<void> {
    return DbUtil.createTable(CREATE_TABLE_SQL)
  }

  // 插入数据
  insert(record: RecordPO): Promise<number> {
    return DbUtil.insert(TABLE_NAME, record, COLUMNS)
  }

  // 删除数据
  deleteById(id: number): Promise<number> {
    //1.删除条件
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(ID_COLUMN, id)
    //2.执行删除操作
    return DbUtil.delete(predicates)
  }

  //根据日期查询数据
  listByDate(date: number): Promise<RecordPO[]> {
    // 1.查询条件
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(DATE_COLUMN, date)
    //2.执行查询操作
    return DbUtil.queryForList(predicates, COLUMNS)
  }
}

const recordModel = new RecordModel()
export default recordModel as RecordModel