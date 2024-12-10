#include "product.h"

Product::Product() {
    m_name = "";
}

QString Product::name() const
{
    return m_name;
}

void Product::setName(const QString &newName)
{
    m_name = newName;
}
