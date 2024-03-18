import relationalStore from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import Logger from './Logger'
import { ColumnInfo, ColumnType } from '../bean/ColumnInfo'


const DB_FILENAME: string = 'HeiMaHealthy.db'

// 数据库工具类
class DbUtil {
  private rdbStore: relationalStore.RdbStore

  // 初始化数据库
  initDatabase(context: common.UIAbilityContext): Promise<void> {
    return new Promise((resolve, reject) => {
      let storeConfig: relationalStore.StoreConfig = {
        name: DB_FILENAME,
        securityLevel: relationalStore.SecurityLevel.S1
      }
      relationalStore.getRdbStore(context, storeConfig)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          Logger.debug('rdbStore 初始化完成！')
          resolve()
        }).catch(error => {
        Logger.error('rdbStore 初始化失败！', JSON.stringify(error))
        reject(error)
      })
    })
  }

  // 新建表
  createTable(sqlStr: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore.executeSql(sqlStr)
        .then(() => {
          Logger.debug('创建表成功', sqlStr)
          resolve()
        }).catch(error => {
        Logger.error('创建表失败', JSON.stringify(error))
        reject(error)
      })
    })
  }

  // 插入数据
  insert(tableName: string, obj: any, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建新增数据
      let valuesBucket = this.buildValueBucket(obj, columns)
      // 2.插入数据
      this.rdbStore.insert(tableName, valuesBucket, (err, id) => {
        if (err) {
          Logger.error('新增失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('新增成功！新增id：', id.toString())
          resolve(id)
        }
      })
    })
  }

  // 删除数据
  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore.delete(predicates, (err, rows) => {
        if (err) {
          Logger.error('删除失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('删除成功！删除行数：', rows.toString())
          resolve(rows)
        }
      })
    })
  }

  // 更新数据
  update(predicates: relationalStore.RdbPredicates, obj: any, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 构建值
      let valueBucket = this.buildValueBucket(obj, columns)
      this.rdbStore.update(valueBucket, predicates, (err, id) => {
        if (err) {
          Logger.error('更新数据失败', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('更新数据成功 id:' + id)
          resolve(id)
        }
      })
    })
  }

  // 查询数据
  queryForList<T>(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(item => item.columnName), (err, resultSet) => {
        if (err) {
          Logger.error('查询数据失败')
          reject(err)
        } else {
          Logger.debug('查询成功！查询行数：', resultSet.rowCount.toString())
          resolve(this.parseResultSet(resultSet, columns))
        }
      })
    })
  }

  // 解析查询结果
  parseResultSet<T>(resultSet: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    // 1.声明最终返回的结果
    let arr = []
    // 2.判断是否有结果
    if (resultSet.rowCount <= 0) {
      return arr
    }
    // 3.处理结果
    while (!resultSet.isAtLastRow) { //
      // 3.1移动到下一行
      resultSet.goToNextRow()
      let obj = {}
      //3.2.解析这行数据，转为对象
      columns.forEach((item: ColumnInfo) => {
        switch (item.type) {
          case ColumnType.LONG:
            obj[item.name] = resultSet.getLong(resultSet.getColumnIndex(item.columnName))
            break
          case ColumnType.DOUBLE:
            obj[item.name] = resultSet.getDouble(resultSet.getColumnIndex(item.columnName))
            break
          case ColumnType.STRING:
            obj[item.name] = resultSet.getString(resultSet.getColumnIndex(item.columnName))
            break
          case ColumnType.BLOB:
            obj[item.name] = resultSet.getBlob(resultSet.getColumnIndex(item.columnName))
            break
        }
      })
      // 添加数据到数组
      arr.push(obj)
    }
    return arr
  }

  // 构建ValueBucket
  buildValueBucket(obj: any, columns: ColumnInfo[]) {
    let value = {}
    columns.forEach(info => {
      let val = obj[info.name]
      if (val !== 'undefined') {
        value[info.columnName] = val
      }
    })
    return value
  }
}

const utils = new DbUtil()

export default utils as DbUtil