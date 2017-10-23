#ifndef ABSTRACTMODEL_H
#define ABSTRACTMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QDebug>
#include <algorithm>

class QVariantListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int length READ length NOTIFY lengthChanged)
public:
    explicit QVariantListModel(QObject *parent = nullptr)
        : QAbstractListModel(parent) {

    }

    int rowCount(const QModelIndex& parent) const override {
        if (!parent.isValid())
            return 0;
        return _values.size();
    }

    QVariant data(const QModelIndex& index, int role) const override {
        int size = _values.size();
        if (index.row() < 0 || index.row() >= size)
            return QVariant();
        if (role == Qt::DisplayRole || role == Qt::EditRole)
            return dataAt(index);

        return QVariant();
    }

signals:

    void lengthChanged();

public slots:

    QVariant get(int index) {
        if(index < 0) return QVariant();
        return _values.at(index);
    }

    void append(int value) {
        beginInsertRows(QModelIndex(), _values.size(), _values.size());
        _values.push_back(value);
        endInsertRows();
        emit lengthChanged();
    }

    void remove(int index, int count) {
        if(index < 0) return;
        if(count <= 0) return;
        int end = index + count;
        beginRemoveRows(QModelIndex(), index, end - 1);
        _values.erase(_values.begin() + index, _values.begin() + end);
        endRemoveRows();
        emit lengthChanged();
    }

    void move(int from, int to, int count) {
        if(from < 0) return;
        if(to < 0) return;
        if(count <= 0) return;

        // to must be < from
        if(from < to) {
            std::swap(from, to);
        }

        int fromEnd = from + count;
        beginMoveRows(QModelIndex(), from, fromEnd - 1, QModelIndex(), to);
        std::swap_ranges(
            _values.begin() + from,
            _values.begin() + fromEnd,
            _values.begin() + to
        );
        endMoveRows();
        emit lengthChanged();
    }

    void clear() {
        if(length() == 0) return;
        int from = 0;
        int to = length() - 1;
        beginRemoveRows(QModelIndex(), from, to);
        _values.clear();
        endRemoveRows();
    }


private:

    int length() const {
        return _values.size();
    }

    QVariant& dataAt(const QModelIndex& index) {
        return _values.at(index.row());
    }

    const QVariant& dataAt(const QModelIndex& index) const {
        return _values.at(index.row());
    }

    std::vector<QVariant> _values;
};

#endif // ABSTRACTMODEL_H
