#ifndef PRODUCT_H
#define PRODUCT_H

#include <QString>

class Product
{
public:
    Product();

    QString name() const;
    void setName(const QString &newName);

private:
    QString m_name;
};

#endif // PRODUCT_H
